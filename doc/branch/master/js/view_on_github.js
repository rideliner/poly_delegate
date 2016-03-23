// encoding: utf-8
// Copyright (c) 2016 Nathan Currier

// Modified from https://github.com/docmeta/rubydoc.info

function createGithubLinks() {
  if (match = window.location.pathname.match(/([^\/]+)(?:\/doc)?\/(?:branch|tag)\/([^\/]+)\//)) {
    var github_project = match[1];
    var github_marker = match[2];

    $(".source_code").each(function() {
      if (match = $(this).find(".info.file").text().match(/^# File '([^']+)', line (\d+)/)) {
        var file = match[1];
        var line = match[2];

        var url = "https://github.com/rideliner/" + github_project + "/blob/" + github_marker + "/" + file + "#L" + line;
        var href = '<a target="_blank" href="' + url + '">View on Github</a>';

        $(this).before(' <span class="showSource">[' + href + ']</span>');
      }
    });
  }
}

$(createGithubLinks)
