# stuff copy pasted from Sha.jl

# Common update and digest functions which work across SHA1 and SHA2

# update! takes in variable-length data, buffering it into blocklen()-sized pieces,
# calling transform!() when necessary to update the internal hash state.
function update!(context::MD5_CTX,data)
    T = typeof(context)
    # We need to do all our arithmetic in the proper bitwidth
    UIntXXX = typeof(context.bytecount)

    # Process as many complete blocks as possible
    len = convert(UIntXXX, length(data))
    data_idx = convert(UIntXXX, 0)
    usedspace = context.bytecount % blocklen(T)
    while len - data_idx + usedspace >= blocklen(T)
        # Fill up as much of the buffer as we can with the data given us
        for i in 1:(blocklen(T) - usedspace)
            context.buffer[usedspace + i] = data[data_idx + i]
        end

        transform!(context)
        context.bytecount += blocklen(T) - usedspace
        data_idx += blocklen(T) - usedspace
        usedspace = convert(UIntXXX, 0)
    end

    # There is less than a complete block left, but we need to save the leftovers into context.buffer:
    if len > data_idx
        for i = 1:(len - data_idx)
            context.buffer[usedspace + i] = data[data_idx + i]
        end
        context.bytecount += len - data_idx
    end
end

lrot(b,x,width) = ((x << b) | (x >> (width - b)))
