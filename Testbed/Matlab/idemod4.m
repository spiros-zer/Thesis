% A simple function to emulate Index DeModulation (IDeM). Currently supporting
% IDeM for two timeslots only.

%%%%% INDEX DEMODULATION %%%%%
function [helper, output, IM_ERROR, QAMDEMOD_ERROR] = idemod4(y, M, SYMBOLS_IM, input)
% imod's counterpart.
helper = zeros(size(y));
if M==2 %BPSK
    filter=0.5;
else %QPSK
    filter=0.5;
end
% INDEX DEMODULATION
for i=1:length(y)
    passed = norm(y(i)) - filter > 0;
    % A "helper" vector is created to help with error calculations. This
    % vector has the following attributes:
    % 1) size equal to the input signal y
    % 2) thus, a 1-on-1 analogy with the symbols in y
    % 3) each element in helper, contains a case number regarding the
    %    symbols/enegry of the input signal
    %
    % % 1st case: RX perceives NULL Energy for a NULL Timeslot
    if ~passed && SYMBOLS_IM(i)==0
        helper(i,1)=00;
    % % 2nd case: RX perceives NULL Energy for a NOT NULL Timeslot
    elseif ~passed && SYMBOLS_IM(i)~=0
        helper(i,1)=01;
    % % 3rd case: RX perceives USEFUL Energy for a NULL Timeslot
    elseif passed && SYMBOLS_IM(i)==0
        helper(i,1)=10;
    % % 4th case: RX perceives USEFUL Energy for a NOT NULL Timeslot
    else
        helper(i,1)=11;
    end
end
% QAM DEMODULATION
output = symbol_to_bits(y,helper,M);
% ERROR CALCULATION FOR IM
[IM_ERROR,QAMDEMOD_ERROR] = error_calc(input,output,helper);
end

function output = symbol_to_bits(y,helper,M)
output = zeros(size(y));
if M==2
    for i=1:length(helper)
        if helper(i)==0
            output(i)=32;
        elseif helper(i)==01
            output(i)=08;
        elseif helper(i)==10
            output(i)=-1;
        else
            output(i) = qamdemod(y(i),M,'bin','OutputType','bit');
        end
    end
else
    j=1;
    for i=1:length(helper)
        if helper(i)==0
            output(j)=32;
        elseif helper(i)==01
            output(j)=08;
        elseif helper(i)==10
            output(j)=-1;
        else
            bits = qamdemod(y(i), M,'bin','OutputType','bit');
            output(j) = bits(1);
            output(j+1) = bits(2);
            j=j+1;
        end
        j=j+1;
    end
end
end

function [IM_ERROR, QAMDEMOD_ERROR] = error_calc(input, output, helper)
% IM_ERROR: errors from mistakes during index demodulation. They can be
% identified using the helper vector by looking for cases "01" and "10".
IM_ERROR = numel(find(helper==01|helper==10));
% DEMOD_ERROR: errors from mistakes during qamdemod, where a symbol got
% mixed up and resulted in wrong bits.
% The case of NOISY SYMBOLS (=symbols produced by noise during index
% demodulation, resulting in more bits overall) or LOST SYMBOLS
% (symbols that got lost during index demodulation, resulting in less bits
% overall) are NOT CALCULATED in this scope.
QAMDEMOD_ERROR=0;
j=1;
for i=1:length(output)
    if output(i)==08
        j=j+1;
    elseif output(i)~=32 && output(i)~=-1
        if output(i)~=input(j)
            QAMDEMOD_ERROR = QAMDEMOD_ERROR + 1;
        end
        j=j+1;
    end
end
end