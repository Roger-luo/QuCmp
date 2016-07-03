function process!{N}(circuit::Circuit{N},input::AbstractVector)
    for unit in circuit.gates
        if N==bitnum(unit)
            input = unit.gate(input)
        else

        end
    end
end

import Base.bin
function bin(num::Integer,)

function process!(unit::GateUnit,input::AbstractVector)
    N = round(Int,log2(length(input)))
    for i=0:2^N-1
        input[i]
