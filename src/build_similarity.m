function similarity = build_similarity(ratings)
%BUILD_SIMILARITY Compute a symmetric user-user similarity matrix.

	if nargin < 1 || isempty(ratings)
		similarity = [];
		return;
	end

	num_users = size(ratings, 1);
	similarity = zeros(num_users, num_users);

	for user_i = 1:num_users
		similarity(user_i, user_i) = 1;
		for user_j = user_i + 1:num_users
			score = cosine_similarity(ratings(user_i, :), ratings(user_j, :));
			similarity(user_i, user_j) = score;
			similarity(user_j, user_i) = score;
		end
	end
end
