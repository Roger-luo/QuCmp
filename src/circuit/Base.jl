abstract AbstractModels
abstract QuCircuit<:AbstractModels


##########################
# Gates
##########################

type Gate{T,N}
    name::AbstractString
    op::AbstractOp{T,N}
    Gate{T,N}(name::AbstractString,op::AbstractOp{T,N}) = new(name,op)
end

Gate{N}(name::AbstractString,op::MatrixOp{N})=Gate{AbstractMatrix,N}(name,op)

Hadamard = Gate("Hadamard gate",OP_Hadamard)
X        = Gate("Paili X",OP_sigmax)
Y        = Gate("Paili Y",OP_sigmay)
Z        = Gate("Paili Z",OP_sigmaz)

function call{T,N}(gate::Gate{T,N})
    return gate.op()
end

"""
GateUnit
---

GateUnit is for the gate unit in a circuit

pos:
the first number in pos is the the column number
the second number in pos is the bits' IDs that is realted to this gate
eg.

'''
  --block 1--|----block 2----|
1 -----------|---------------|
2 ----[A]----|---------------|
3 -----------|---------------|
4 -----------|-----[   ]-----|
5 -----------|-----[ B ]-----|
6 -----------|-----[   ]-----|
'''

The position of gate B is (2,4,5,6)
"""
abstract AbstractGateUnit

type GateUnit{T,N}<:AbstractGateUnit
    gate::Gate{T,N}
    pos::Vector{Int}
    # TODO : time layer?
    # time_layer::Real

    GateUnit{T,N}(gate::Gate{T,N},pos::Vector{Int})=new(gate,pos)
end

GateUnit{T,N}(gate::Gate{T,N},pos::Vector{Int}) = GateUnit{T,N}(gate,pos)
GateUnit{T,N}(gate::Gate{T,N},pos::Tuple{Int}) = GateUnit{T,N}(gate,collect(pos))
GateUnit{T,N}(gate::Gate{T,N},pos::Int...) = GateUnit{T,N}(gate,collect(pos))

bitnum{T,N}(unit::GateUnit{T,N}) = N

############################
# Circuits
############################

type Circuit{N} <: QuCircuit
    gates::Array{GateUnit,1}
end

Circuit(num::Integer,gates::Array{GateUnit,1}) = Circuit{num}(gates)
Circuit(num::Integer)=Circuit{num}(Array(GateUnit,0))

############################
# Constructor
############################

max(a::Int) = a

function addgate!{T,N,M}(circuit::Circuit{N},gate::Gate{T,M},pos::Int...)
    # Bounds check
    @assert length(pos)==M+1 "number of qubits involved do not match"
    @assert max(pos[2:end]...)<=N

    push!(circuit.gates,GateUnit(gate,ntuple(x->sort(collect(pos))[x],length(pos))...))
    sort!(circuit.gates,alg=QuickSort,by=x->x.pos[1])
end
