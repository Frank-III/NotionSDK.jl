@inline _parse_header(headers::Config) = HEADER_NAME .=> collect(values(headers))




function pick(base, keyvars::Symbol...)
    res = [base[key] for key in keyvars if (key ∈ keys(base)) && (base[key] ≠ nothing)]
    Dict(res...)
end

@inline get_auth(base) = :auth ∈ keys(base) ? auth : nothing
