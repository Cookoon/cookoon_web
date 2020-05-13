import application from "stimulus_application";
import { definitionsFromContext } from "stimulus/webpack-helpers";
import "./search.scss";
import {changeImageSubmitTag} from "./change_image_submit_tag.js";
changeImageSubmitTag();

const context = require.context('./', true, /_controller\.js$/);
application.load(definitionsFromContext(context));
