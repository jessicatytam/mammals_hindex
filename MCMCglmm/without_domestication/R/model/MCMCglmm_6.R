#installation
install.packages("MCMCglmm")
#libraries
library(MCMCglmm)

#load data
imp_list <- readRDS("MCMCglmm/data/imp_list_2_wo_dom.rds")
random_trees <- readRDS("MCMCglmm/data/random_trees_wo_dom.rds")

#imputation list
imp_6 <- imp_list[6]

#non-informative prior
prior1 <- list(R = list(V = diag(1), nu = 0.002),
               G = list(G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*1000)))

#model
mod_list3_6 <- vector(mode = "list", length = 100)
for (i in 1:length(random_trees)) {
  for (j in 1:length(imp_6)) {
    #mod_list3_6[[j+(i-1)*length(imp_6)]] <- sprintf("%s is i and %s is j\n", i, j)
    mod_list3_6[[j+(i-1)*length(imp_6)]] <- MCMCglmm(h ~ logmass +
                                                       abs_lat +
                                                       humanuse_bin +
                                                       poly(iucn_bin, 2) +
                                                       log_sumgtrends,
                                                     random = ~ animal,
                                                     family = "poisson",
                                                     pedigree = random_trees[[i]],
                                                     dat = imp_6[[j]],
                                                     nitt = 13000*10,
                                                     thin = 10*10,
                                                     burnin = 3000*10,
                                                     prior = prior1)
  }
}

#save the models
saveRDS(mod_list3_6, "MCMCglmm/without_domestication/outputs/mod_list3_6.rds")
