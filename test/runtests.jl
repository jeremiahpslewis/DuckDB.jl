using Test
using DataFrames
import DuckDB

@testset "DB Connection" begin
    con = DuckDB.connect(":memory:")
    @test isa(con, Base.RefValue{Ptr{Nothing}})
end

@testset "Test README" begin
    con = DuckDB.DB(":memory:")

    res = DuckDB.execute(con, "CREATE TABLE integers(date DATE, jcol INTEGER)")
    res = DuckDB.execute(
        con,
        "INSERT INTO integers VALUES ('2021-09-27', 4), ('2021-09-28', 6), ('2021-09-29', 8)",
    )
    res = DuckDB.execute(con, "SELECT * FROM integers")

    @test isa(DuckDB.toDataFrame(res), DataFrame)

    @test isa(DuckDB.toDataFrame(con, "SELECT * FROM integers"), DataFrame)
    DuckDB.disconnect(con)

end

# TODO: This seems to be broken in current version, "HUGE" type not supported error.
# @testset "Create table huge" begin
#     con = DuckDB.connect(":memory:")
#     res = DuckDB.execute(con,"CREATE TABLE huge(id INTEGER, data HUGE);")
#     res = DuckDB.execute(con,"INSERT INTO huge VALUES (1,), (2, 1761718171), (3, 171661889178);")
#     res = DuckDB.toDataFrame(con,"SELECT * FROM huge")
#     DuckDB.disconnect(con)        
# end

@testset "Interval type" begin
    con = DuckDB.connect(":memory:")
    res = DuckDB.execute(con, "CREATE TABLE interval(interval INTERVAL);")
    res = DuckDB.execute(
        con,
        """
INSERT INTO interval VALUES 
(INTERVAL 5 HOUR),
(INTERVAL 12 MONTH),
(INTERVAL 12 MICROSECOND),
(INTERVAL 1 YEAR);
""",
    )
    res = DuckDB.toDataFrame(con, "SELECT * FROM interval;")
    @test isa(res, DataFrame)
    DuckDB.disconnect(con)
end

@testset "Interval type" begin
    con = DuckDB.connect(":memory:")
    res = DuckDB.execute(con, "CREATE TABLE timestamp(timestamp TIMESTAMP , data INTEGER);")
    res = DuckDB.execute(
        con,
        "INSERT INTO timestamp VALUES ('2021-09-27 11:30:00.000', 4), ('2021-09-28 12:30:00.000', 6), ('2021-09-29 13:30:00.000', 8);",
    )
    res = DuckDB.execute(con, "SELECT * FROM timestamp;")
    res = DuckDB.toDataFrame(res)
    @test isa(res, DataFrame)
    DuckDB.disconnect(con)
end

@testset "Items table" begin
    con = DuckDB.connect(":memory:")
    res = DuckDB.execute(
        con,
        "CREATE TABLE items(item VARCHAR, value DECIMAL(10,2), count INTEGER);",
    )
    res = DuckDB.execute(
        con,
        "INSERT INTO items VALUES ('jeans', 20.0, 1), ('hammer', 42.2, 2);",
    )
    res = DuckDB.toDataFrame(con, "SELECT * FROM items;")
    @test isa(res, DataFrame)
    DuckDB.disconnect(con)
end

@testset "Integers and dates table" begin
    using DuckDB
    con = DuckDB.DB()
    DBInterface.execute(con, "CREATE TABLE integers(date DATE, data INTEGER);")
    # res = DuckDB.execute(con, "CREATE TABLE integers(date DATE, data INTEGER);")
    res = DuckDB.execute(
        con,
        "INSERT INTO integers VALUES ('2021-09-27', 4), ('2021-09-28', 6), ('2021-09-29', 8);",
    )
    res = DuckDB.execute(con, "SELECT * FROM integers;")
    res = DuckDB.toDataFrame(res)
    @test isa(res, DataFrame)
    DuckDB.disconnect(con)
end
