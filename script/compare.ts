import {parse, gt} from "https://deno.land/std@0.205.0/semver/mod.ts";
import {fetchExtend} from "https://deno.land/x/simple_utility@v1.4.2/mod.ts";
import {Endpoints} from "npm:@octokit/types@12.1.1";

type LatestRelease = Endpoints["GET /repos/{owner}/{repo}/releases/latest"]["response"]["data"];

async function getLatestRelease(repo:string){
    return <LatestRelease>await fetchExtend(`https://api.github.com/repos/${repo}/releases/latest`, "json");
}

const {tag_name: tagCurrent} = await getLatestRelease(Deno.env.get("GITHUB_REPOSITORY") ?? "");
const {tag_name: tagLatest} = await getLatestRelease("denoland/deno");

const result = gt(parse(tagLatest), parse(tagCurrent));