#!/usr/bin/env ruby
# frozen_string_literal: true

require "octokit"

Octokit.auto_paginate = true
user = "ifyouseewendy"

stars = Octokit.starred(user).map do |star|
  {
    avatar_url: star.owner.avatar_url,
    owner: star.owner.login,
    name: star.name,
    html_url: star.html_url,
    description: star.description,
    stargazers_count: star.stargazers_count,
    watchers_count: star.watchers_count,
    language: star.language,
    homepage: star.homepage
  }
end

puts "stars count: #{stars.count}"
