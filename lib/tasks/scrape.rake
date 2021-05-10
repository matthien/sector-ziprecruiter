task scrape: :environment do
  puts 'HERE'

  require 'open-uri'

  URL = 'https://www.ziprecruiter.com/jobs-search?search=Software%20Engineer'

  doc = Nokogiri::HTML(open(URL))

  postings = doc.search('div.job_title_raw')

  postings.each do |p|
    job_title = p.search('a.job_link > h2').text
    location = p.search('div.company_details > span')[1].text
    team = p.search('div.company_details > span')[0].text
    url = p.search('a.job_link')[0]['href']

    # skip persisting job if it already exists in db
    if Job.where(job_title:job_title, location:location, team:team, url:url).count <= 0
      Job.create(
        job_title:job_title,
        location:location,
        team:team,
        url:url)

      puts 'Added: ' + (job_title ? job_title : '')
    else
      puts 'Skipped: ' + (job_title ? job_title : '')
    end

  end
end
