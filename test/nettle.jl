import Nettle

@testset "compare with Nettle" begin
    for offset ∈ [0,10^3, 10^4, 10^5]
        iter = offset:(offset+1000)
        for l ∈ iter
            s = randstring(l)
            @test Nettle.hexdigest("md5", s) == bytes2hex(md5(s))
        end
    end
end
