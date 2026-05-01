function [recommendations, similarity, ratings] = user_based_cf(data_source, user_index, top_n)
%USER_BASED_CF Build user-based recommendations from a matrix or file path.

	if nargin < 2 || isempty(user_index)
		user_index = 1;
	end
	if nargin < 3 || isempty(top_n)
		top_n = 5;
	end

	if ischar(data_source) || (exist('isstring', 'builtin') && isstring(data_source))
		[ratings, ~, item_ids] = load_data(char(data_source));
	else
		ratings = data_source;
		item_ids = 1:size(ratings, 2);
	end

	if isempty(ratings)
		recommendations = struct('item_index', {}, 'item_id', {}, 'score', {});
		similarity = [];
		return;
	end

	similarity = build_similarity(ratings);
	recommendations = recomend_movies(ratings, similarity, user_index, top_n, item_ids);
end
