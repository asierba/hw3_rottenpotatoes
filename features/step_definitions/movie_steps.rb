# Adds a declarative step here for populating the DB with movies.
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a movie to add to the database.
    Movie.create!(movie)
  end
end

# Makes sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.content.rindex(e1), "'#{e1}' not found in page"
  assert page.content.rindex(e2), "'#{e2}' not found in page"
  assert page.content.rindex(e1) < page.body..rindex(e1), "'#{e2}' is shown before '#{e1}'"
end

# Makes it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rating|
    if uncheck
      step %Q{I uncheck "ratings_#{rating.strip}"}
    else
      step %Q{I check "ratings_#{rating.strip}"}
    end
  end
end

Then /I should see all of the movies/ do
  @moviesInDB = Movie.all.count
  @moviesInTable = all("table#movies tr").count - 1
  assert @moviesInDB == @moviesInTable, "movies in database and html page differ #{@moviesInDB} - #{@moviesInTable}, "  
end
