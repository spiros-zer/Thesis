% A simple function to emulate Index Modulation (IM). Currently supporting
% IM for two timeslots only.

%%%%% INDEX MODULATION %%%%%
function SYMBOLS_IM = imod(SYMBOLS)
% Index Modulation is applied to an input SYMBOL stream. Each time, a
% case is made on whether the TX will transmit (1 in timeslot) or not (0 in
% timeslot).
% In this case we experiment with 2-IM where each time we use 2 timeslots
% and thus gives us 4 cases.
k = 1;
i = 1;
SYMBOLS_IM = zeros(length(SYMBOLS)*3, 1); %we preallocate for speed
while true
    format = randi(4,1,1);
    switch format
        case 1 %00
            SYMBOLS_IM(k,1) = 0;
            SYMBOLS_IM(k+1,1) = 0;
            k = k+2;
        case 2 %01
            SYMBOLS_IM(k,1) = 0;
            SYMBOLS_IM(k+1,1) = SYMBOLS(i);
            i = i+1;
            k = k+2;
        case 3 %10
            SYMBOLS_IM(k,1) = SYMBOLS(i);
            i = i+1;
            SYMBOLS_IM(k+1,1) = 0;
            k = k+2;
        otherwise %11
            %In this case we got to give extra caution when
            %i=length(SYMBOLS). So we are at the last symbol which means
            %we can only satisfy the first part of our case. That is why
            %with an if clause, a 0 is added as the secondary part (where
            %the other symbol should have been).
            SYMBOLS_IM(k,1) = SYMBOLS(i);
            i = i+1;
            if i >= length(SYMBOLS)
                SYMBOLS_IM(k+1,1) = 0;
            else
                SYMBOLS_IM(k+1,1) = SYMBOLS(i);
                i = i+1;
            end
            k = k+2;
    end
    if i > length(SYMBOLS)
        break
    end
end
% At this point the output SYMBOLS_IM stream has beed generated which is
% bigger in length than it's originator SYMBOLS.
SYMBOLS_IM(k:end,:) = []; %we delete the null elements due to preallocation
end
