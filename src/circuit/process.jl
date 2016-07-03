function process!{N}(circuit::Circuit{N},input::AbstractVector)
    for unit in circuit.gates
        if N==bitnum(unit)
            input = unit.gate(input)
        else

        end
    end
end

function process!(unit::GateUnit,input::AbstractVector)
