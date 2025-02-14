dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  DBI::dbExecute(con, "set search_path to test_platform")

  test_that("prepare functions work", {
    x <- insert_new_source(con)
    expect_equal(dim(x), c(1,1))
    x <- insert_new_author("Maja Zalo\u017enik", "MZ", "maja.zaloznik@gov.si",
                      folder = NA, con, schema = "test_platform")
    expect_equal(x, 0)
    expect_message(add_author_folder("MZ", "O:/Avtomatizacija/umar-data/mz", con, "test_platform"))
    x <- insert_new_category("Maja Zalo\u017enik", con)
    expect_equal(x, 1)
    x <- insert_new_category_relationship("Maja Zalo\u017enik", con, "test_platform")
    expect_equal(x, 1)

    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet14")
    x <- insert_new_table(df, con, "test_platform")
    expect_equal(x, 2)
    x <- insert_new_category_table(df, con, "test_platform")
    expect_equal(x, 2)
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
    x <- insert_new_table_dimensions(df, con, "test_platform")
    expect_equal(x, 3)
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet17")
    x <- insert_new_dimension_levels(df, con, "test_platform")
    expect_equal(x, 6)
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
    x <- insert_new_series(df, con, "test_platform")
    expect_equal(x, 5)
    df <- openxlsx::read.xlsx(testthat::test_path("testdata", "struct_tests.xlsx"), sheet = "Sheet19")
    x <- insert_new_series_levels(df, con, "test_platform")
    expect_equal(x, 7)
  })
})



