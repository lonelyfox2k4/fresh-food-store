package org.example.model.content;

import lombok.Getter;

@Getter
public enum NewsStatus {
    DRAFT((byte)0), PUBLISHED((byte)2), ARCHIVED((byte)3);
    private byte value;
    NewsStatus(byte value) { this.value = value; }
    public byte getValue() { return value; }
}