# define userAgent property (and helper properties ua_*)
ua_project='ipcc-countries'
ua_projectUrl='http://github.com/eric-brechemier/ipcc-countries/'
ua_contactEmail='medea@eric.brechemier.name'
userAgent="$ua_project ($ua_projectUrl; $ua_contactEmail)"
echo "User-Agent: $userAgent"
