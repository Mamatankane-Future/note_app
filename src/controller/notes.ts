import { RequestHandler } from "express";
import Note from "../models/notes";
import createHttpError from "http-errors";
import mongoose from "mongoose";


export const getNotes: RequestHandler = async (req, res,next) => {
    try {
        const notes = await Note.find();
        res.status(200).json(notes);
    } catch (error) {
        next(error);
    } 
}

interface NoteIDParam {
    NoteId?: string,
}

export const getNote: RequestHandler<NoteIDParam, unknown, unknown, unknown> =async (req, res, next) => {
    const noteId = req.params.NoteId;
    try{
        if (!mongoose.isValidObjectId(noteId)) throw createHttpError(400, "Invalid NoteID");
        const note= await Note.findById(noteId);
        if (!note) throw createHttpError(204, "Note not found!");
        res.status(200).json(note);
    }
    catch(error){
        next(error);
    }
}

interface noteBody{
    title?: string,
    text?: string,
}

export const createNotes: RequestHandler<unknown, unknown, noteBody,unknown> = async (req, res, next) => {
    const { title, text } = req.body;
    try {
        if (!title) throw createHttpError(400, "Note missing title!"); 
        const note = await Note.create({
            "title": title,
            "text": text,
        });
        res.status(201).json({message: "Note added!",note: note});
    } catch (error) {
        next(error);
    }
}

export const updateNotes: RequestHandler<NoteIDParam, unknown, noteBody, unknown> = async (req, res, next) => {
    const { title, text } = req.body;
    const noteId = req.params.NoteId;

    try {
        if (!mongoose.isValidObjectId(noteId)) throw createHttpError(400, "Invalid noteID!");
        const note = await Note.findById(noteId);
        if (!note) throw createHttpError(204, "Note not found!");
        if (title)  note.title = title;
        if (text) note.text = text;
        const newNote = await note.save();
        res.status(201).json({message: "Note updated!", note: newNote});
    } catch (error) {
        next(error);
    }
    
}

export const deleteNotes: RequestHandler <NoteIDParam, unknown, unknown, unknown> = async (req, res, next) => {
    const noteId = req.params.NoteId;
    try {
        if (!mongoose.isValidObjectId(noteId)) throw createHttpError(400, "Invalid noteID!");
        const note = await Note.findById(noteId);
        if (!note) throw createHttpError(204, "Note not found!");
        await note.deleteOne();
        res.sendStatus(202);
    }
    catch(error){
        next(error);
    }
}
