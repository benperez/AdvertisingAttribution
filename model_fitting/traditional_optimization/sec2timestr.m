function timestr = sec2timestr(sec)
% Convert a time measurement from seconds into a human readable string.

if sec < 0
    timestr = '???:???';
    return
end

% Convert seconds to other units
d = floor(sec/86400); % Days
sec = sec - d*86400;
h = floor(sec/3600); % Hours
sec = sec - h*3600;
m = floor(sec/60); % Minutes
sec = sec - m*60;
s = floor(sec); % Seconds

% Create time string
if d > 0
    timestr = sprintf('%02dd:%02dh',d,h);
elseif h > 0
    timestr = sprintf('%02dh:%02dm',h,m);
else
    timestr = sprintf('%02dm:%02ds',m,s);
end

