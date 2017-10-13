package eu.operando.feedback.repository.dagger;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

import javax.inject.Scope;

/**
 * Created by Matei_Alexandru on 11.10.2017.
 * Copyright © 2017 RomSoft. All rights reserved.
 */

@Scope
@Retention(RetentionPolicy.CLASS)
@interface MyApplicationScope {
}