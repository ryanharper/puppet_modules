Facter.add("provider") do
  setcode do
    provider_id = Facter.value('ec2_profile')
    if provider_id != ''
      "aws"
     else
      "unknown"
    end
  end
end
