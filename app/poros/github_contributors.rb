class GithubContributors

  def self.contributors_info
    github_contributor_data = GithubService.contributors_info
<<<<<<< Updated upstream
    github_contributor_data.each_with_object({}) do |contributor, hash|
      if [26797256, 78388882, 5446926, 78574189].include?(contributor[:id])
        hash[contributor[:id]] = {name: contributor[:login], contributions: contributor[:contributions]}
      end
    end

=======
      github_contributor_data.each_with_object({}) do |contributor, hash|
        if [26797256, 78388882, 5446926, 78574189].include?(contributor[:id])
          hash[contributor[:id]] = {name: contributor[:login], contributions: contributor[:contributions]}
        end
      end
>>>>>>> Stashed changes
  end
end
