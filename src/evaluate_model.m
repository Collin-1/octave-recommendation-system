function metrics = evaluate_model(ratings, test_fraction, num_trials)
%EVALUATE_MODEL Estimate rating prediction quality with random holdout splits.

	if nargin < 2 || isempty(test_fraction)
		test_fraction = 0.2;
	end
	if nargin < 3 || isempty(num_trials)
		num_trials = 5;
	end

	known_positions = find(~isnan(ratings));
	if isempty(known_positions)
		metrics = struct('rmse', NaN, 'mae', NaN, 'evaluated_ratings', 0, ...
										 'test_fraction', test_fraction, 'trials', num_trials);
		return;
	end

	rmse_values = zeros(num_trials, 1);
	mae_values = zeros(num_trials, 1);
	evaluated_counts = zeros(num_trials, 1);

	for trial = 1:num_trials
		trial_ratings = ratings;
		test_size = max(1, round(test_fraction * numel(known_positions)));
		permutation = randperm(numel(known_positions), test_size);
		test_positions = known_positions(permutation);

		trial_ratings(test_positions) = NaN;
		similarity = build_similarity(trial_ratings);

		errors = zeros(test_size, 1);
		absolute_errors = zeros(test_size, 1);
		for k = 1:test_size
			[user_index, item_index] = ind2sub(size(ratings), test_positions(k));
			predicted = predict_rating(trial_ratings, similarity, user_index, item_index);
			actual = ratings(user_index, item_index);
			errors(k) = predicted - actual;
			absolute_errors(k) = abs(errors(k));
		end

		rmse_values(trial) = sqrt(mean(errors .^ 2));
		mae_values(trial) = mean(absolute_errors);
		evaluated_counts(trial) = test_size;
	end

	metrics = struct();
	metrics.rmse = mean(rmse_values);
	metrics.mae = mean(mae_values);
	metrics.evaluated_ratings = sum(evaluated_counts);
	metrics.test_fraction = test_fraction;
	metrics.trials = num_trials;
end
