#installation
install.packages("MCMCglmm")
#libraries
library(MCMCglmm)

#load data
imp_list <- readRDS("data/imp_list_2.rds")
random_trees <- readRDS("data/random_trees.rds")

#imputation list
imp_5 <- imp_list[5]

#non-informative prior
prior1 <- list(R = list(V = diag(1), nu = 0.002),
               G = list(G1 = list(V = diag(1), nu = 1, alpha.mu = 0, alpha.V = diag(1)*1000)))

#model
mod_list_5 <- vector(mode = "list", length = 100)
for (i in 1:length(random_trees)) {
  for (j in 1:length(imp_5)) {
    #mod_list_5[[j+(i-1)*length(imp_5)]] <- sprintf("%s is i and %s is j\n", i, j)
    mod_list_5[[j+(i-1)*length(imp_5)]] <- MCMCglmm(h ~ logmass +
                                                      abs_lat +
                                                      humanuse_bin +
                                                      domestication_bin +
                                                      poly(iucn_bin, 2) +
                                                      log_sumgtrends,
                                                    random = ~ animal,
                                                    family = "poisson",
                                                    pedigree = random_trees[[i]],
                                                    dat = imp_5[[j]],
                                                    nitt = 13000*10,
                                                    thin = 10*10,
                                                    burnin = 3000*10,
                                                    prior = prior1)
  }
}

#save the models
saveRDS(mod_list_5, "model_2_nt/outputs/mod_list_5.rds")
