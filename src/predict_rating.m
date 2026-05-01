function predicted_rating = predict_rating(ratings, similarity, user_index, item_index)
%PREDICT_RATING Predict a rating using user-based collaborative filtering.

	if nargin < 4
		error('predict_rating requires ratings, similarity, user_index, and item_index');
	end

	num_users = size(ratings, 1);
	if user_index < 1 || user_index > num_users
		error('user_index is out of range');
	end

	known_ratings = ratings(~isnan(ratings));
	if isempty(known_ratings)
		predicted_rating = 0;
		return;
	end

	user_ratings = ratings(user_index, :);
	user_known = user_ratings(~isnan(user_ratings));
	if isempty(user_known)
		user_mean = mean(known_ratings);
	else
		user_mean = mean(user_known);
	end

	item_ratings = ratings(:, item_index);
	item_known = item_ratings(~isnan(item_ratings));
	if isempty(item_known)
		item_mean = mean(known_ratings);
	else
		item_mean = mean(item_known);
	end

	neighbors = find(~isnan(item_ratings) & (1:num_users)' ~= user_index);
	if isempty(neighbors)
		predicted_rating = user_mean;
		return;
	end

	neighbor_sims = similarity(user_index, neighbors)';
	neighbor_ratings = item_ratings(neighbors);

	neighbor_means = zeros(numel(neighbors), 1);
	for k = 1:numel(neighbors)
		neighbor_row = ratings(neighbors(k), :);
		neighbor_known = neighbor_row(~isnan(neighbor_row));
		if isempty(neighbor_known)
			neighbor_means(k) = item_mean;
		else
			neighbor_means(k) = mean(neighbor_known);
		end
	end

	denominator = sum(abs(neighbor_sims));
	if denominator == 0
		predicted_rating = user_mean;
		return;
	end

	centered_scores = neighbor_ratings - neighbor_means;
	predicted_rating = user_mean + sum(neighbor_sims .* centered_scores) / denominator;

	rating_min = min(known_ratings);
	rating_max = max(known_ratings);
	predicted_rating = min(max(predicted_rating, rating_min), rating_max);
end
