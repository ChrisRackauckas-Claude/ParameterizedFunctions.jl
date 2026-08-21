"""
$(DocStringExtensions.README)
"""
module ParameterizedFunctions

using DocStringExtensions: DocStringExtensions
using DataStructures: DataStructures, OrderedDict
using DiffEqBase: DiffEqBase
using ModelingToolkit: ModelingToolkit, System, tosymbol
using ModelingToolkitBase: ModelingToolkitBase, @parameters
using PrecompileTools: @compile_workload, @setup_workload
using Symbolics: Symbolics, @variables
using SymbolicUtils: SymbolicUtils, BasicSymbolic

import LinearAlgebra
import SciMLBase

include("ode_def_opts.jl")
include("utils.jl")
include("dict_build.jl")
include("macros.jl")

export @ode_def, ode_def_opts, @ode_def_bare, @ode_def_all

@setup_workload begin
    @compile_workload begin
        f = @ode_def begin
            dx = a * x - b * x * y
            dy = -c * y + d * x * y
        end a b c d
        u = [2.0, 3.0]
        p = [1.5, 1.0, 3.0, 1.0]
        f(u, p, 1.0)
        f.jac(u, p, 1.0)
        f.tgrad(u, p, 1.0)
    end
end

end # module
