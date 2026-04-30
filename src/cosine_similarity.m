function similarity = cosine_similarity(vector_a, vector_b)
%COSINE_SIMILARITY Compute cosine similarity on overlapping observed values.

	if nargin < 2
		error('cosine_similarity requires two input vectors');
	end

	vector_a = vector_a(:);
	vector_b = vector_b(:);

	valid_mask = ~isnan(vector_a) & ~isnan(vector_b);
	if ~any(valid_mask)
		similarity = 0;
		return;
	end

	vector_a = vector_a(valid_mask);
	vector_b = vector_b(valid_mask);

	norm_a = sqrt(sum(vector_a .^ 2));
	norm_b = sqrt(sum(vector_b .^ 2));

	if norm_a == 0 || norm_b == 0
		similarity = 0;
		return;
	end

	similarity = sum(vector_a .* vector_b) / (norm_a * norm_b);
end
