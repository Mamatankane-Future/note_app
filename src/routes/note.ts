import { Router } from "express";
import * as NotesController from "../controller/notes";

const router= Router();

router.get("/", NotesController.getNotes);
router.get("/:NoteId", NotesController.getNote);
router.post("/", NotesController.createNotes);
router.patch("/:NoteId", NotesController.updateNotes);
router.delete("/:NoteId", NotesController.deleteNotes);

export default router;