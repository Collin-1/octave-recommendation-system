function [ratings, user_ids, item_ids] = load_data(file_path)
%LOAD_DATA Load a ratings file into a user-item matrix.
%   The loader accepts either a dense numeric matrix or a triplet CSV with
%   columns [user_id, item_id, rating]. Missing ratings are represented as NaN.

	if nargin < 1 || isempty(file_path)
		script_dir = fileparts(mfilename('fullpath'));
		project_dir = fileparts(script_dir);
		file_path = fullfile(project_dir, 'data', 'ratings.csv');
	end

	ratings = [];
	user_ids = [];
	item_ids = [];

	if exist(file_path, 'file') ~= 2
		return;
	end

	file_info = dir(file_path);
	if isempty(file_info) || file_info.bytes == 0
		return;
	end

	fid = fopen(file_path, 'r');
	if fid < 0
		return;
	end

	lines = {};
	while true
		line = fgetl(fid);
		if ~ischar(line)
			break;
		end
		line = strtrim(line);
		if ~isempty(line)
			lines{end + 1, 1} = line; %#ok<AGROW>
		end
	end
	fclose(fid);

	if isempty(lines)
		return;
	end

	numeric_rows = {};
	numeric_counts = [];
	for i = 1:numel(lines)
		tokens = strsplit(lines{i}, ',');
		row = nan(1, numel(tokens));
		is_numeric_row = true;
		for j = 1:numel(tokens)
			value = str2double(strtrim(tokens{j}));
			if isnan(value) && ~strcmpi(strtrim(tokens{j}), 'NaN')
				is_numeric_row = false;
				break;
			end
			row(j) = value;
		end

		if is_numeric_row
			numeric_rows{end + 1, 1} = row; %#ok<AGROW>
			numeric_counts(end + 1) = numel(row); %#ok<AGROW>
		end
	end

	if isempty(numeric_rows)
		return;
	end

	data = cell2mat(numeric_rows);

	if all(numeric_counts == 3)
		user_col = data(:, 1);
		item_col = data(:, 2);
		rating_col = data(:, 3);

		user_ids = unique(user_col(:)');
		item_ids = unique(item_col(:)');
		ratings = nan(numel(user_ids), numel(item_ids));

		for k = 1:size(data, 1)
			user_index = find(user_ids == user_col(k), 1);
			item_index = find(item_ids == item_col(k), 1);
			if ~isempty(user_index) && ~isempty(item_index)
				ratings(user_index, item_index) = rating_col(k);
			end
		end
	else
		ratings = data;
		user_ids = 1:size(ratings, 1);
		item_ids = 1:size(ratings, 2);
	end
end
