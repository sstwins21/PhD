library(ggplot2)

sliding_window <- function (het, size, slide, total) {
  het_wind <- vector()
  pos_wind <- vector()
  first <- 1
  last <- size
  ended = "false"
  beg <- 1
  while(last <= total) {
    i <- beg
    count <- 0
    cat("going through",first,last,"\n")
    region_het = 0
    next_first <- first + slide
    next_true <- "true"
  
    
    while(het$V2[i] >= first && het$V2[i] <= last && i <= length(het$V2)) {
      if( het$V2[i] >= next_first && next_true == "true") {
        next_true <- "false"
        beg <- i
      }
      
      #cat(het$V2[i],region_het," + ", het$V3[i], "\n")
      region_het = region_het + het$V3[i]   
      i <- i+1
      count <- count + 1
    
    }
    if(next_true == "true") {
      beg <- i
    }
    
    
    pos <- first + (last - first)/2
    results <- region_het/(count)
    #cat(pos,results,"\n")
    het_wind <- append(het_wind, results)
    pos_wind <- append(pos_wind, pos)
    first <- next_first
    last <- first + size - 1
  
    if(last >= total && ended == "false") {
      ended <- "true"
      last <- total
    }
  }
  
  result.data <- data.frame(pos_wind, het_wind)
  return (result.data)
}


chrom <- read.table("/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/gapclosed.fasta.masked.fai")


all_data <- read.table("/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/gatk/slurm/longranger/dsuit/investigate/axx500_dsuit.txt")

for(i in 1:18) {

  chrom_num  <- i 
  size <- chrom$V2[chrom_num]/20
  slide <- as.integer(size/2)
  
  scaff <- paste("scaffold_",chrom_num, sep="")
  
  
  
  f_d <- all_data[which(all_data$V1 == scaff), c(1,2,3)]
  f_dM <- all_data[which(all_data$V1 == scaff), c(1,2,4)]
  d_f <- all_data[which(all_data$V1 == scaff), c(1,2,5)]
  colnames(f_d) <- c("V1", "V2" ,"V3")
  colnames(f_dM) <- c("V1", "V2" ,"V3")
  colnames(d_f) <- c("V1", "V2" ,"V3")


  cli_win <- sliding_window(f_d, size, slide, chrom$V2[i])
  acan_win <- sliding_window(f_dM, size, slide, chrom$V2[i])
  ances_win <- sliding_window(d_f, size, slide, chrom$V2[i])


  newDT <- data.frame(cli_win$pos_wind, cli_win$het_wind, acan_win$het_wind, ances_win$het_wind)
  colnames(newDT) <- c("pos", "f_d", "f_dM", "d_f") 


  plot_name <- paste("axg_",chrom_num,".jpeg", sep= "")
  colors <- c("f_d" = "green", "f_dM" = "red", "d_f" = "black")
  gg_name<- paste("scaffold",i,"_plot", sep= "")
  



  g <- ggplot(data = newDT, mapping = aes(x = pos))  +
  geom_line(aes(y = f_d, color = "f_d")) + geom_line(aes(y = f_dM, color = "f_dM")) + geom_line(aes(y = d_f, color = "d_f"))  + labs( x= "position bp", y="Heterozygosity") + xlim(1, chrom$V2[i]) + scale_color_manual(name='Allele', values = colors)  
  assign(gg_name, get("g"))
  
}


jpeg("scaffold_1.jpeg", quality = 75)
scaffold1_plot


dev.off()


jpeg("scaffold_2.jpeg", quality = 75)
scaffold2_plot


dev.off()

jpeg("scaffold_3.jpeg", quality = 75)
scaffold3_plot


dev.off()

jpeg("scaffold_4.jpeg", quality = 75)
scaffold4_plot


dev.off()


jpeg("scaffold_5.jpeg", quality = 75)
scaffold5_plot


dev.off()


jpeg("scaffold_6.jpeg", quality = 75)
scaffold6_plot


dev.off()

jpeg("scaffold_7.jpeg", quality = 75)
scaffold7_plot


dev.off()


jpeg("scaffold_8.jpeg", quality = 75)
scaffold8_plot


dev.off()


jpeg("scaffold_9.jpeg", quality = 75)
scaffold9_plot


dev.off()

jpeg("scaffold_10.jpeg", quality = 75)
scaffold10_plot


dev.off()

jpeg("scaffold_11.jpeg", quality = 75)
scaffold11_plot


dev.off()


jpeg("scaffold_12.jpeg", quality = 75)
scaffold12_plot


dev.off()


jpeg("scaffold_13.jpeg", quality = 75)
scaffold13_plot


dev.off()


jpeg("scaffold_14.jpeg", quality = 75)
scaffold14_plot


dev.off()


jpeg("scaffold_15.jpeg", quality = 75)
scaffold15_plot


dev.off()


jpeg("scaffold_16.jpeg", quality = 75)
scaffold16_plot


dev.off()


jpeg("scaffold_17.jpeg", quality = 75)
scaffold17_plot


dev.off()


jpeg("scaffold_18.jpeg", quality = 75)
scaffold18_plot


dev.off()


