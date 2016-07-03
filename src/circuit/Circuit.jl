using Expokit
import Base: show

include("../const.jl")

abstract AbstractModels
abstract QuCircuit<:AbstractModels

type QuState{N}
    s::AbstractVector
end

# TODO show(io::IO,state::QuState)

include("op.jl")

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

############################
# Circuits
############################

type Circuit{N} <: QuCircuit
    gates::Array{GateUnit,1}
end

Circuit(num::Integer,gates::Array{GateUnit,1}) = Circuit{num}(gates)
Circuit(num::Integer)=Circuit{num}(Array(GateUnit,0))

############################
# constructor
############################
function addgate!{T,N,M}(circuit::Circuit{N},gate::Gate{T,M},pos::Int...)
    # Bounds check
    @assert length(pos)==M "number of qubits involved do not match"

    push!(circuit.gates,GateUnit(gate,pos...))
end
