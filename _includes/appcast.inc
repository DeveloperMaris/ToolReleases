<?xml version="1.0" encoding="utf-8"?>
<rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" version="2.0">
    <channel>
        <title>{{ site.github.project_title }}</title>
        <description>Most recent changes with links to updates.</description>
        {% for release in site.github.releases %}
            {% unless release.draft %}
                {% unless release.prerelease and page.release_only %}
                    <item>
                        <title>{{ release.name }}</title>
                        <description><![CDATA[{{ release.body | markdownify }}]]></description>
                        <pubDate>{{ release.published_at | date_to_rfc822 }}</pubDate>
                        {% for asset in release.assets limit:1 %}
                            {% assign build_nums = asset.name | replace_first:'ToolReleases_v','' | replace_first:'.b',',' | remove_first:'.zip' | split:',' %}
                            {% if build_nums.size == 2 %}
                                {% assign version = build_nums[1] %}
                                {% assign short_version = release.tag_name | remove_first:'v' %}
                                {% if short_version contains '1.4' %}
                                    <sparkle:minimumSystemVersion>11.2</sparkle:minimumSystemVersion>
                                {% else %}
                                    <sparkle:minimumSystemVersion>10.15</sparkle:minimumSystemVersion>
                                {% endif %}
                                {{min_version}}
                            {% else %}
                                {% assign version = release.tag_name | remove_first:'v' %}
                            {% endif %}
                            <enclosure
                                url="{{ asset.browser_download_url }}"
                                sparkle:version="{{ version }}"
                                {% if short_version %}sparkle:shortVersionString="{{ release.tag_name | remove_first:'v' }}"{% endif %}
                                length="{{ asset.size }}"
                                type="application/octet-stream" />
                        {% endfor %}
                    </item>
                {% endunless %}
            {% endunless %}
        {% endfor %}
    </channel>
</rss>