############################
# Circuits
############################

type Circuit{N} <: QuCircuit{N}
    gates::Array{GateUnit,1}
end

Circuit(num::Integer,gates::Array{GateUnit,1}) = Circuit{num}(gates)
Circuit(num::Integer)=Circuit{num}(Array(GateUnit,0))

# TODO
# function show(io::IO,circuit::Circuit)
# end

###########################
# Stablizer Circuit
# Circuits with only Hadamard, C-NOT, R (Phase)
# followed by only one bits measurement
###########################

type stlzCircuit{N} <: QuCircuit{N}
    gates::Array{GateUnit,1}
end

stlzCircuit(num::Integer,gates::Array{GateUnit,1}) = StableCircuit{num}(gates)
stlzCircuit(num::Integer) = StableCircuit{num}(Array(GateUnit,0))

############################
# Circuit Constructor
############################

max(a::Int) = a

function addgate!{T,N,M}(circuit::QuCircuit{N},gate::Gate{T,M},pos::Int...)
    # Bounds check
    @assert length(pos)==M+1 "number of qubits do not match"
    @assert max(pos[2:end]...)<=N

    push!(circuit.gates,GateUnit(gate,ntuple(x->sort(collect(pos))[x],length(pos))...))
    sort!(circuit.gates,alg=QuickSort,by=x->x.pos[1])
end
