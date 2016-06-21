% pportaddr = 'C020';
pportaddr = 'E000';

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

while (true)
       input_data=io32(pportobj,pportaddr)
%        input_data=bitand(input_data, 27) % filtro bits 4, 3, 1 y 0
end