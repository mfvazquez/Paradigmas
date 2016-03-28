 global parallel_port;
      
pportaddr = 'C020';
% pportaddr = '378';

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


input_data=io32(pportobj,pportaddr);
bit1_old = bitand(input, 1);
bit2_old = bitand(input, 2);
% while true
%     input_data=io32(pportobj, pportaddr);
%     bit1 = bitand(input, 1);
%     bit2 = bitand(input, 2);
%     if (bit1_old ~= bit1)
%         bit1_change = GetSecs
%         bit1_old = bit1;
%     end
%     if (bit2_old ~= bit2)
%         bit2_change = GetSecs
%         bit2_old = bit2;
%     end
% end
bit1_change = 0;
bit2_change = 0;
while true
    input_data=io32(pportobj, pportaddr);
    bit1 = bitand(input, 1);
    bit2 = bitand(input, 2);
    if (bit1 == 0)
        bit1_old = 0;
    end
    if (bit2 == 0)
        bit2_old = 0;
    end
    
    if (bit1 == 1 && bit1_old == 0)
        bit1_change = GetSecs
        bit1_old = bit1;
    end
    if (bit2 == 1 && bit2_old == 0)
        bit2_change = GetSecs
        bit2_old = bit2;
    end
    if (bit1_change ~= 0 && bit2_change ~= 0)
        delay = bit1_change - bit2_change
        bit1_change = 0;
        bit2_change = 0;
    end
end
