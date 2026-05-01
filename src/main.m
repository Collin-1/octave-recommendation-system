function [recommendations, similarity, ratings, metrics] = main()
%MAIN Run the recommendation system end-to-end.

	script_dir = fileparts(mfilename('fullpath'));
	project_dir = fileparts(script_dir);
	data_file = fullfile(project_dir, 'data', 'ratings.csv');

	[ratings, user_ids, item_ids] = load_data(data_file);

	if isempty(ratings)
		ratings = [
			5, 4, NaN, 1, NaN, 2;
			4, NaN, 5, 1, 2, NaN;
			NaN, 2, 4, 4, 1, 5;
			1, 2, NaN, 4, 4, 5;
			2, NaN, 1, 5, 4, 4
		];
		user_ids = 1:size(ratings, 1);
		item_ids = 1:size(ratings, 2);
	end

	similarity = build_similarity(ratings);

	user_index = 1;
	top_n = 3;
	recommendations = recomend_movies(ratings, similarity, user_index, top_n, item_ids);
	metrics = evaluate_model(ratings, 0.2, 5);

	fprintf('User-based collaborative filtering\n');
	fprintf('Users: %d, Items: %d\n', size(ratings, 1), size(ratings, 2));
	fprintf('Recommendations for user %d:\n', user_ids(user_index));

	if isempty(recommendations)
		fprintf('  No unrated items available.\n');
	else
		for k = 1:numel(recommendations)
			fprintf('  Item %d -> %.3f\n', recommendations(k).item_id, recommendations(k).score);
		end
	end

	if ~isempty(metrics) && isfield(metrics, 'rmse')
		fprintf('Evaluation RMSE: %.4f\n', metrics.rmse);
		fprintf('Evaluation MAE: %.4f\n', metrics.mae);
	end
end
