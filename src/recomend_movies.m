function recommendations = recomend_movies(ratings, similarity, user_index, top_n, item_ids)
%RECOMEND_MOVIES Rank unrated items for a user and return the top results.

	if nargin < 4 || isempty(top_n)
		top_n = 5;
	end
	if nargin < 5 || isempty(item_ids)
		item_ids = 1:size(ratings, 2);
	end

	user_ratings = ratings(user_index, :);
	unrated_items = find(isnan(user_ratings));

	if isempty(unrated_items)
		recommendations = struct('item_index', {}, 'item_id', {}, 'score', {});
		return;
	end

	scores = zeros(numel(unrated_items), 1);
	for k = 1:numel(unrated_items)
		item_index = unrated_items(k);
		scores(k) = predict_rating(ratings, similarity, user_index, item_index);
	end

	[sorted_scores, order] = sort(scores, 'descend');
	top_count = min(top_n, numel(order));

	recommendations = repmat(struct('item_index', [], 'item_id', [], 'score', []), top_count, 1);
	for k = 1:top_count
		item_index = unrated_items(order(k));
		recommendations(k).item_index = item_index;
		recommendations(k).item_id = item_ids(item_index);
		recommendations(k).score = sorted_scores(k);
	end
end
