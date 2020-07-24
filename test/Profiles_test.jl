
using DataFrames: DataFrame
using Iex
using Iex.Connect

TEST_SLEEP_TIME = 15.0

profile_functions_test = [
    :company,
    :insider_roster,
    :insider_summary,
    :logo,
    :peers,
    :balance_sheet,
    :earnings,
    :income,
    :news,
]

params = (
    token=ENV["IEX_SANDBOX_API_KEY"],
    url="https://sandbox.iexapis.com/",
    version="stable",
)
iex = init_connection(;url=params.url, version=params.version,
    token=params.token);


@testset "StockProfiles" begin
    for f in profile_functions_test
        @eval begin
            testname = string($f)
            @testset "Testing $testname" begin
                data = $f(iex, "AAPL")
                if testname == "company"
                    @test typeof(data) === Dict{String,Any}
                    @test length(data) === 20
                elseif testname in ["insider_roster", "insider_summary", "news"]
                    @test typeof(data) === Array{Any,1}
                    @test length(data) === 10
                elseif testname == "logo"
                    @test typeof(data) == Dict{String,Any}
                    @test length(data) == 1
                elseif testname == "peers"
                    @test typeof(data) === Array{Any,1}
                    @test length(data) === 4
                elseif testname in ["balance_sheet", "earnings", "income"]
                    @test typeof(data) == Dict{String,Any}
                    @test length(data) == 2
                elseif testname == "news"
                    @test typeof(data) == Array{Any,1}
                    @test length(data) == 10
                end
            end
        end
        sleep(TEST_SLEEP_TIME + 2*rand()) #as to not overload the API
    end

    @testset "Testing get_stocks" begin
        data = Iex.get_stocks(iex, "chart", Dict("symbol" => "AAPL"))
        @test typeof(data) == Array{Any,1}
        @test length(data) == 21
    end
end