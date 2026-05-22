library(DESeq2)
library(ggplot2)
library(pheatmap)

outdir <- "/Users/teihiroshisakai/Documents/Genome_Analysis/Project/output/transcriptomics/DEseq_output"
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

samples <- data.frame(
  sample = c(
    "ERR1797972", "ERR1797973", "ERR1797974",
    "ERR1797969", "ERR1797970", "ERR1797971"
  ),
  condition = factor(
    c("BHI", "BHI", "BHI", "Serum", "Serum", "Serum"),
    levels = c("BHI", "Serum")
  ),
  file = c(
    "/Users/teihiroshisakai/Documents/Genome_Analysis/Project/output/transcriptomics/htseq_counts_out/RNA-Seq_BHI/ERR1797972.htseq.counts.txt",
    "/Users/teihiroshisakai/Documents/Genome_Analysis/Project/output/transcriptomics/htseq_counts_out/RNA-Seq_BHI/ERR1797973.htseq.counts.txt",
    "/Users/teihiroshisakai/Documents/Genome_Analysis/Project/output/transcriptomics/htseq_counts_out/RNA-Seq_BHI/ERR1797974.htseq.counts.txt",
    "/Users/teihiroshisakai/Documents/Genome_Analysis/Project/output/transcriptomics/htseq_counts_out/RNA-Seq_Serum/ERR1797969.htseq.counts.txt",
    "/Users/teihiroshisakai/Documents/Genome_Analysis/Project/output/transcriptomics/htseq_counts_out/RNA-Seq_Serum/ERR1797970.htseq.counts.txt",
    "/Users/teihiroshisakai/Documents/Genome_Analysis/Project/output/transcriptomics/htseq_counts_out/RNA-Seq_Serum/ERR1797971.htseq.counts.txt"
  ),
  stringsAsFactors = FALSE
)

read_htseq <- function(path, sample_name) {
  x <- read.delim(
    path,
    header = FALSE,
    col.names = c("feature", "count"),
    stringsAsFactors = FALSE
  )
  x <- x[!grepl("^__", x$feature), , drop = FALSE]
  colnames(x)[2] <- sample_name
  x
}

count_list <- mapply(
  read_htseq,
  samples$file,
  samples$sample,
  SIMPLIFY = FALSE
)

counts_df <- Reduce(
  function(x, y) merge(x, y, by = "feature", all = TRUE),
  count_list
)

counts_df[is.na(counts_df)] <- 0L
rownames(counts_df) <- counts_df$feature

count_matrix <- as.matrix(counts_df[, -1])
storage.mode(count_matrix) <- "integer"

coldata <- data.frame(
  row.names = samples$sample,
  condition = samples$condition
)

dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = coldata,
  design = ~ condition
)

keep <- rowSums(counts(dds) >= 10) >= 3
dds <- dds[keep, ]

dds <- DESeq(dds)

res <- results(dds, contrast = c("condition", "Serum", "BHI"))
res <- res[order(res$padj), ]

res_df <- as.data.frame(res)
res_df$gene <- rownames(res_df)

write.csv(res_df, file.path(outdir, "DESeq2_Serum_vs_BHI_all.csv"))
sig <- subset(res_df, !is.na(padj) & padj < 0.05)
write.csv(sig, file.path(outdir, "DESeq2_Serum_vs_BHI_sig_padj0.05.csv"))

norm_counts <- counts(dds, normalized = TRUE)
write.csv(as.data.frame(norm_counts), file.path(outdir, "normalized_counts.csv"))

vsd <- vst(dds, blind = FALSE)

pdf(file.path(outdir, "PCA_plot.pdf"))
print(plotPCA(vsd, intgroup = "condition"))
dev.off()

pdf(file.path(outdir, "MA_plot.pdf"))
plotMA(res, ylim = c(-5, 5))
dev.off()

res_df$significance <- "Not significant"
res_df$significance[!is.na(res_df$padj) & res_df$padj < 0.05 & res_df$log2FoldChange > 1] <- "Up in Serum"
res_df$significance[!is.na(res_df$padj) & res_df$padj < 0.05 & res_df$log2FoldChange < -1] <- "Down in Serum"

volcano_plot <- ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj), color = significance)) +
  geom_point(alpha = 0.7, size = 1.5, na.rm = TRUE) +
  scale_color_manual(values = c(
    "Up in Serum" = "firebrick",
    "Down in Serum" = "steelblue",
    "Not significant" = "grey70"
  )) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  labs(
    title = "Volcano plot: Serum vs BHI",
    x = "log2 fold change",
    y = "-log10 adjusted p-value"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(outdir, "Volcano_plot.pdf"),
  plot = volcano_plot,
  width = 8,
  height = 6
)

top_genes <- rownames(sig)

if (length(top_genes) < 30) {
  top_genes <- rownames(res_df[!is.na(res_df$padj), ])[1:min(30, nrow(res_df[!is.na(res_df$padj), ]))]
} else {
  top_genes <- top_genes[1:30]
}

heatmap_mat <- assay(vsd)[top_genes, , drop = FALSE]

annotation_col <- data.frame(condition = coldata$condition)
rownames(annotation_col) <- rownames(coldata)

pdf(file.path(outdir, "Heatmap_top_genes.pdf"), width = 8, height = 10)
pheatmap(
  heatmap_mat,
  scale = "row",
  annotation_col = annotation_col,
  clustering_distance_rows = "euclidean",
  clustering_distance_cols = "euclidean",
  clustering_method = "complete",
  show_rownames = TRUE,
  show_colnames = TRUE,
  main = "Top DE genes"
)
dev.off()

write.csv(samples, file.path(outdir, "sample_table_used.csv"), row.names = FALSE)
writeLines(capture.output(sessionInfo()), file.path(outdir, "sessionInfo.txt"))

