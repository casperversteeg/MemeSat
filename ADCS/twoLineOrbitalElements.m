function [ Flight ] = twoLineOrbitalElements(S)

[m, n] = size(S);
assert(m == 2 && n == 69 && ischar(S), ...
    strcat("The two-line orbital elements description must be ",...
    "a 2x69 array of characters"));

Flight = struct('catalog', [], 'classification', [], 'launch_year', [],...
    'launch_of_year', [], 'piece_of_launch', [], 'epoch_yr', [], ...
    'epoch_day', [], 'mean_motion1', [], 'mean_motion2', [], ...
    'bstar', [], 'ephem_type', [], 'tle_num', [],...
    'inclination', [], 'rightascension', [], 'eccentricity',[],...
    'arg_perigee', [], 'mean_anomaly', [], 'mean_motion', [], ...
    'rev_at_epoch', [], 'sec_per_orbit', []);

% --- Line 1 ---
check1 = 0;
% Set catalog number and check lines [3 - 7]
cat1 = str2double(S(1,3:7));
cat2 = str2double(S(2,3:7));
assert(cat1 == cat2, "Satellite catalog number mismatch.");
Flight.catalog = cat1;

% Set classification [8]
Flight.classification = S(1,8);

% Set international designators [10 - 17]
Y = str2double(S(1, 10:11));
if Y <= 56
    Flight.launch_year = 2000 + Y;
else
    Flight.launch_year = 1900 + Y;
end
Flight.launch_of_year = str2double(S(1,12:14));
Flight.piece_of_launch = S(1,15:17);

% Set epoch [19 - 32]
Y = str2double(S(1, 19:20));
if Y <= 56
    Flight.epoch_yr = 2000 + Y;
else
    Flight.epoch_yr = 1900 + Y;
end
Flight.epoch_day = str2double(S(1, 21:32));

% Set first and second derivative of mean motion [34 - 52]
Flight.mean_motion1 = str2double(S(1, 34:43));
M = strsplit(S(1,45:52), '-');
Flight.mean_motion2 = str2double(strcat(M{1}, 'e-', M{2}));

% Set BSTAR [54 - 61]
B = strsplit(S(1,54:61), '-');
Flight.bstar = str2double(strcat(B{1}, 'e-', B{2}));

% Set ephemeris type (always zero [0]) [63]
assert(str2double(S(1,63)) == 0, "Ephemeris type non-zero.");
Flight.ephem_type = 0;

% Element set number (a.k.a. TLE number) [65 - 68]
Flight.tle_num = str2double(S(1,65:68));

% Check first checksum [69]
for i = 1:68
    if strcmp(S(1,i), '-')
        check1 = check1 + 1;
    elseif ~isnan(str2double(S(1,i)))
        check1 = check1 + str2double(S(1,i));
    end
end
assert(mod(check1, 10) == str2double(S(1,69)), "Checksum error line 1");

% --- Line 2 ---
check2 = 0;
% Set inclination [9 - 16]
Flight.inclination = str2double(S(2, 9:16));

% Set right ascension of ascending node [18 - 25]
Flight.rightascension = str2double(S(2, 18:25));

% Set eccentricity [27 - 33]
Flight.eccentricity = str2double(strcat('0.', S(2, 27:33)));

% Set argument of perigee [35 - 42]
Flight.arg_perigee = str2double(S(2, 35:42));

% Set mean anomaly [44 - 51]
Flight.mean_anomaly = str2double(S(2, 44:51));

% Set mean motion (revolutions/day) [53 - 63]
Flight.mean_motion = str2double(S(2, 53:63));
Flight.sec_per_orbit = 1/(Flight.mean_motion * (1/24/3600));

% Set revolution number at epoch [64 - 68]
Flight.rev_at_epoch = str2double(S(2, 64:68));

% Check second checksum [69]
for i = 1:68
    if strcmp(S(2,i), '-')
        check2 = check2 + 1;
    elseif ~isnan(str2double(S(2,i)))
        check2 = check2 + str2double(S(2,i));
    end
end
assert(mod(check2, 10) == str2double(S(2,69)), "Checksum error line 2");

end