# Octave Recommendation System

This project implements a simple user-based collaborative filtering recommender in Octave.

## What it does

- Loads ratings from `data/ratings.csv`
- Builds a user-user cosine similarity matrix
- Predicts unrated items for a chosen user
- Evaluates the model with a random holdout split

## Data format

`load_data.m` accepts either of these formats:

- A dense numeric matrix, where each row is a user and each column is an item
- A triplet CSV with columns `user_id,item_id,rating`

Missing ratings should be left blank in the dense matrix or omitted from the triplet file.

## Files

- `src/load_data.m` reads and normalizes the ratings input
- `src/cosine_similarity.m` computes cosine similarity for overlapping ratings
- `src/build_similarity.m` builds the full user-user similarity matrix
- `src/predict_rating.m` predicts a single unrated score
- `src/recomend_movies.m` ranks the best unseen items for a user
- `src/user_based_cf.m` provides a simple wrapper for the workflow
- `src/evaluate_model.m` estimates RMSE and MAE with random holdout testing
- `src/main.m` runs the demo end-to-end

## Run

From the project root, run:

```octave
octave --quiet --eval "addpath('src'); main();"
```

If `data/ratings.csv` is empty, `main.m` uses a small built-in demo matrix so the pipeline still runs.
