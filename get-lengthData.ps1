$headers = @{
    "Accept"             = "application/json, text/plain, */*"
    "Accept-Encoding"    = "gzip, deflate, br"
    "Accept-Language"    = "en-US,en;q=0.9"
    "Origin"             = "https://howlongtoread.com"
    "Referer"            = "https://howlongtoread.com/"
    "Sec-Fetch-Dest"     = "empty"
    "Sec-Fetch-Mode"     = "cors"
    "Sec-Fetch-Site"     = "same-site"
    "sec-ch-ua"          = "`"Chromium`";v=`"116`", `"Not)A;Brand`";v=`"24`", `"Google Chrome`";v=`"116`""
    "sec-ch-ua-mobile"   = "?0"
    "sec-ch-ua-platform" = "`"Windows`""
}

Function get-bookData {
    param(
        $auth,
        $title
    )

    $path = [uri]::EscapeDataString("$auth $title")

    $r = Invoke-WebRequest -UseBasicParsing -Uri "https://api.howlongtoread.com/books/search/$path" -Headers $headers

    $closeMatches = $r.Content | ConvertFrom-Json  # | Where-Object { $_.title -like "*$title*" }

    $closest = @($closeMatches)[0]

    $id = $closest.id

    if ($closeMatches.length) {
        # Write-Host "Going with the closest match: " $closest.author $closest.title "-- ID: $id"
    }
    else {
        Write-Host "No close matches found for $path"
        return
    }

    $q = Invoke-WebRequest -UseBasicParsing -Uri "https://api.howlongtoread.com/books/id/$id" -Headers $headers
    $bookData = $q.Content | ConvertFrom-Json

    [PSCustomObject]@{
        pageCount     = $bookData.numPages
        wordCount     = $bookData.wordCount
        duration_mins = [int]($bookData.readingTime / 60)
        author        = $closest.author
        title         = $closest.title
    }
}

Import-Csv "$PSScriptRoot\sample_list.csv" | ForEach-Object { get-bookData -auth $_.auth -title $_.title } | Format-Table
