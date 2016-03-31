 global parallel_port;
      

 pportaddr = '378';
% pportaddr = '0378';

if exist('pportaddr','var') && ~isempty(pportaddr)

    fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
    pportaddr = hex2dec(pportaddr);
    pportobj = io32;
    io32status = io32(pportobj);
    io32(pportobj,pportaddr,0)

    if io32status ~= 0
        error('io32 failure: could not initialise parallel port.\n');
    end

end

while true
    input_data=io32(pportobj,pportaddr)
end
 
% input_data=io32(pportobj,pportaddr);
% bit1_old = bitand(input_data, 1);
% bit2_old = bitand(input_data, 2);
% bit1_change = 0;
% bit2_change = 0;
% input_data_old=input_data
% while true
% 
%     input_data=io32(pportobj, pportaddr)
%     if (input_data ~= input_data_old)
%         input_data
%         input_data_old = input_data;
%     end
%     bit1 = bitand(input_data, 1);
%     bit2 = bitand(input_data, 2);
%     if (bit1 == 0)
%         bit1_old = 0;
%     end
%     if (bit2 == 0)
%         bit2_old = 0;
%     end
%     
%     if (bit1 == 1 && bit1_old == 0)
%         bit1_change = GetSecs
%         bit1_old = bit1;
%     end
%     if (bit2 == 1 && bit2_old == 0)
%         bit2_change = GetSecs
%         bit2_old = bit2;
%     end
%     if (bit1_change ~= 0 && bit2_change ~= 0)
%         delay = bit1_change - bit2_change
%         bit1_change = 0;
%         bit2_change = 0;
%     end
% end
