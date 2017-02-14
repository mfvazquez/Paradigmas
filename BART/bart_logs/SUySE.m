% Cambia Subject y session
%**************************************************************************
%Function name: SUySE
%Author: 
%Date Created: 
%Description: 
%Input: 
%Output:
%Function calls:
%Revision history:
%Name    Date          Comment
%**************************************************************************

function susessdata = SUySE(ori_file)
%If filename is not given.
if nargin == 0
    [fname, pname]= uigetfile('*.*', 'Choose a BART behav file');
    if fname == 0 return; end;
    ori_file= fullfile(pname, fname);	% build full filename from parts
end

[fid, mess] = fopen(ori_file, 'r');
if fid < 0
    error(['open error file ' ori_file mess]);
elseif fid > 2			%open successful
    fseek(fid, 0, 'bof');		%position at bof, no offset
end


p_data = fread(fid, inf, 'char')';
ascii_data = char(p_data);
a = find(ascii_data == 10); % identifica todos los saltos de linea
Nlines = length(a);  %Number of data lines = total lines in file.


% Edith number of subject & Serie
header3 = {};
aux1 = {};
aux2 = [];
aux3 = [];

for j=1:Nlines-1
    header3 = ascii_data(a(j):a(j+1));
    aux1 = strtrim(header3);
    if size(aux1,2) >9
    aux2 = strcmp(aux1(1:8),'Session:');% 'Subject:';
    if aux2
        ni = find(ori_file == '-');
        aux2_2 = ori_file(ni(end)+1:ni(end)+1);
        aux2_3 = find(header3==':');
        ascii_data(a(j)+aux2_3:a(j+1)-2) =  aux2_2;
    end
    end

end