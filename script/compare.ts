import {parse, gt} from "https://deno.land/std@0.205.0/semver/mod.ts";

gt(parse(tagLatest), parse(tagCurrent));