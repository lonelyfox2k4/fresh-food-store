package org.example.model.content;

import lombok.Getter;

@Getter
public enum NewsStatus {
    DRAFT((byte)0), PENDING_APPROVAL((byte)1), PUBLISHED((byte)2), ARCHIVED((byte)3);
    private final byte value;
    NewsStatus(byte v) { this.value = v; }
}