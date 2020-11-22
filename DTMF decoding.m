clc
clear
pkg load ltfat;
% Frequencies by state-of-the-art

# arr.split("0")
function result = split(arr, split_sign = 0)
    # surround by zeros 
    w = [false arr~=0 false]; 
    begin_point   = find( w(2:end) & ~w(1:end-1)); 
    final_point   = find(~w(2:end) &  w(1:end-1)) - 1; 
    result = arrayfun(@(s,e) arr(s:e), begin_point, final_point, 'uniformout', false);
end

function res = decode_digit(seq, fs)
    
    size = length(seq);
    freq = [697 770 852 941 1209 1336 1477]; 
    freq_indices = round( freq / fs * size) + 1;   
    # Recognize digit on freq
    dft_data = gga(seq, freq, fs);
    
    # Find two most probable frequency indexes 
    [y, indx] = max2(abs(dft_data));
    indx = sort(indx, "ascend");
    tonal_encodings = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];
    #for eacch frequency we try to take digit
    if     isequal(indx,[1,5]) res = tonal_encodings(1);
    elseif isequal(indx,[1,6]) res = tonal_encodings(2);
    elseif isequal(indx,[1,7]) res = tonal_encodings(3);
    elseif isequal(indx,[2,5]) res = tonal_encodings(4);
    elseif isequal(indx,[2,6]) res = tonal_encodings(5);
    elseif isequal(indx,[2,7]) res = tonal_encodings(6);
    elseif isequal(indx,[3,5]) res = tonal_encodings(7);
    elseif isequal(indx,[3,6]) res = tonal_encodings(8);
    elseif isequal(indx,[3,7]) res = tonal_encodings(9);
    elseif isequal(indx,[4,5]) res = tonal_encodings(10);
    elseif isequal(indx,[4,6]) res = tonal_encodings(11);
    elseif isequal(indx,[4,7]) res = tonal_encodings(12);
    else                       res = 'none';
    end 
endfunction

function res = decode_sequence(seq, fs)
    splitted = split(seq);
    res = [];
    for i=1:length(splitted);
        digit = decode_digit(splitted{i}, fs);
        res(i) = digit(1);
    end
    res = char(res);
end
[y, fs] = audioread('star_wars.wav');
disp(decode_sequence(transpose(y), fs));