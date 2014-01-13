namespace :db do
	desc "Clear my database"
	task :clear => :environment do 
		Recipe.delete_all
		Photo.delete_all
		Joiner.delete_all
	end
end