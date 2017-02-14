% Cambia unidades a dolares
%**************************************************************************
%Function name: ARtoUS
%Author: Lau
%Date Created: 10022017
%Description: 
%Input: 
%Output:
%Function calls:
%Revision history:
%Name    Date          Comment
%LA      10022017      First version
%**************************************************************************

function usdata = ARtoUS(ori_file)
% nuevos
WagersO{1} = '0.50';
WagersO{2} = '1.5';
WagersO{3} = '2.5';
WagersO{4} = '5.5';
WagersO{5} = '9.5';
WagersO{6} = '14.5';
WagersO{7} = '20.5';
WagersO{8} = '27.5';
WagersO{9} = '34.5';
WagersO{10} = '42.5';
WagersO{11} = '51.5';

% Viejos:
Wagers{1} = '0.05';
Wagers{2} = '0.15';
Wagers{3} = '0.25';
Wagers{4} = '0.55';
Wagers{5} = '0.95';
Wagers{6} = '1.45';
Wagers{7} = '2.05';
Wagers{8} = '2.75';
Wagers{9} = '3.45';
Wagers{10} = '4.25';
Wagers{11} = '5.15';

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

%find editable data lines.

% If in AR, edith CurrentWager
header1 = {};
aux1 = {};
aux2 = [];
aux3 = [];

for j=1:Nlines-1
    header1 = ascii_data(a(j):a(j+1));
    aux1 = strtrim(header1);
    if size(aux1,2) >12
    aux2 = strcmp(aux1(1:13),'CurrentWager:');
    if aux2
        aux3 = find(aux1=='$');
        for n = 1:11
           nch = strcmp(aux1(aux3+1:end), WagersO{n});
           if nch
               wch = find(header1=='$');
               ascii_data(a(j)+wch:a(j+1)-2) =  Wagers{n};
           end
        end
    end
    end

end

% If in AR, edith TotRewardAttrib
if exist('wch') % si el archivo estaba en argentinos existe esta variable
header2 = {};
aux1 = {};
aux2 = [];
aux3 = [];
  for j2=1:Nlines-1
    header2 = ascii_data(a(j2):a(j2+1));
    aux1 = strtrim(header2);
    if size(aux1,2) >15
    aux2 = strcmp(aux1(1:16),'TotRewardAttrib:');
    if aux2
        ar = find(header2=='$');
        argtous = str2num(header2(ar+1:end));
        if argtous>0
            newval = strcat(num2str(argtous/10),'000000');
            cota = (a(j2+1)-2)-(a(j2)+ar)+1;
        ascii_data(a(j2)+ar:a(j2+1)-2) = newval(1:cota) ;
        end
    end
    end  
     

  end
else
end


dlmwrite(ori_file,ascii_data,'delimiter','')
