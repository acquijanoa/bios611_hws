library(tidyverse)
library(FactoMineR)

d <- read_csv("episode_word_counts.csv")

data <- d %>% select(-`Episode URL`)

pca.res = prcomp(scale(data))

pca.res$x

m <- d %>% 
      select(-`Episode URL`) %>% 
      colSums()


d <- d %>% select(`Episode URL` = m) %>% 
        mutate(`Episode URL`= d %>% pull(`Episode URL`))
      
l <- d %>% pivot_longer(cols=captains:devron) %>%
        group_by(name) %>%
        summarise(total=sum(value))
      
l <- l %>% mutate(name = factor(name, l %>% arrange(desc(total)) %>% pull(name)))
      
stds <- d %>%
        summarise(across(captains:devron, sd)) %>%
        pivot_longer(captains:devron) %>%
        rename(std=value) %>%
        arrange(desc(std)) %>%
        mutate(name = factor(name, name)) %>%
        mutate(rank=1:nrow(.))
      
pcs <- pca.res$x %>% as_tibble() %>% mutate(across(PC71:PC176, ~ 0)) %>% as.matrix()

pca.res$rotation      

truncated_stds <- pca.res$rotation %*% pcs %>% t() %>% as_tibble() %>%
        summarise(across(PC71:PC176, sd)) %>%
        pivot_longer(captains:devron) %>%
        rename(std=value) %>%
        arrange(desc(std)) %>%
        mutate(name = factor(name, name)) %>%
        mutate(rank=1:nrow(.))
      
std_df <- rbind(stds %>% mutate(type="full"),
                      truncated_stds %>% mutate(type="truncated"))

#### something else here
#### something else here

plot(leading_pcs)

explained_variance <- pca$sdev^2 / sum(pca$sdev^2)
cumulative_variance <- cumsum(explained_variance)

ggplot(tibble(n=1:nrow(d), cumulative_variance=cumulative_variance), aes(n, cumulative_variance)) + geom_line()

d_shrunk <- d %>%
  select(all_of(std_df %>% filter(type == "truncated" & rank <= 70) %>% pull(name))) %>%
  mutate(first_half = (row_number() < max(row_number()) / 2) * 1)

library(gbm)

train_ii <- runif(nrow(d_shrunk)) < 0.75
train <- d_shrunk %>% filter(train_ii)
test <- d_shrunk %>% filter(!train_ii)

model <- gbm(first_half ~ ., data = train)

## the probability that it corresponds to the first 2 seasons
predicted_part <- predict(model, newdata = test, type = "response")

library(pROC)
pROC(predicted_part,)